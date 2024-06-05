// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

struct Request {
    uint id;
    address author; // Tipo de dado no solidity exclusivo para endereços de carteiras
    string title;
    string description;
    string contact;
    uint timestamp; // Quantidade de segundos desde 01/01/1970 até o instante
    uint goal; // Exemplo: ao invés de trabalhar com *1,19* reais vai ser com *119* centavos
    // 1 ETH = 1 * 10 ^ 18 wei
    // WEI = menor fração do padrão ETH
    uint balance;
    bool open;
    uint donationsCount;
}

contract FloodHelp {
    address admin;
    uint public lastId = 0;
    // Request[] public requests;
    mapping(uint => Request) public requests;

    modifier onlyAdmin() {
        require(
            msg.sender == admin,
            unicode"Você não tem permissão para executar essa operação"
        );
        _;
    }

    constructor() {
        // Vai ser disparado apenas no momento do deploy
        // Função constructor se não declarada vem em branco por default em todos os contratos
        admin = msg.sender;
    }

    function openRequest(
        string memory title,
        string memory description,
        string memory contact,
        uint goal
    ) public {
        // Chamando a função de validação antes de incrementar o lastId
        // Função privada para impedir que seja acessada na blockchain
        validateDuplicatedRequest();

        lastId++;
        requests[lastId] = Request({
            id: lastId,
            title: title,
            description: description,
            contact: contact,
            goal: goal,
            balance: 0,
            timestamp: block.timestamp,
            author: msg.sender,
            open: true,
            donationsCount: 0
        });
    }

    function closeRequest(uint id) public {
        address author = requests[id].author;
        uint balance = requests[id].balance;
        uint goal = requests[id].goal;
        require(
            requests[id].open && (msg.sender == author || balance >= goal),
            unicode"Você não pode fechar este pedido"
        );

        requests[id].open = false;

        if (balance > 0) {
            requests[id].balance = 0;
            payable(author).transfer(balance);
        }
    }

    function donate(uint id) public payable {
        require(
            msg.value > 0,
            unicode"Não foi possível realizar essa operação, valor zerado"
        );
        requests[id].balance += msg.value;
        requests[id].donationsCount++;

        if (requests[id].balance >= requests[id].goal) {
            closeRequest(id);
        }
    }

    function getOpenRequests(
        uint startId,
        uint quantity
    ) public view returns (Request[] memory) {
        require(startId > 0, unicode"startId inválido, não pode ser zero");
        require(
            quantity > 0 && quantity < 30,
            unicode"quantity inválido, não pode ser zero e deve ser menor do que 30"
        );
        Request[] memory result = new Request[](quantity);
        uint id = startId;
        uint count = 0;

        do {
            if (requests[id].open) {
                result[count] = requests[id];
                count++;
            }
            id++;
        } while (count < quantity && id <= lastId);

        return result;
    }

    function validateDuplicatedRequest() private view {
        for (uint i = 1; i <= lastId; i++) {
            if (requests[i].author == msg.sender && requests[i].open) {
                revert(
                    unicode"Você não pode ter mais de um pedido aberto, se quiser pode cancelar e abrir outro"
                );
            }
        }
    }

    function changeAdmin(address newAdmin) public onlyAdmin {
        require(newAdmin != address(0), unicode"Novo administrador inválido");
        admin = newAdmin;
    }
}
