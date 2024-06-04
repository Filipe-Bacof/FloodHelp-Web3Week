// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

struct Request {
    uint id;
    address author; // Tipo de dado no solidity exclusivo para endereços de carteiras
    string title;
    string description;
    string contact;
    uint timestamp; // Quantidade de segundos desde 01/01/1970 até o instante
    uint goal;  // Exemplo: ao invés de trabalhar com *1,19* reais vai ser com *119* centavos
    // 1 ETH = 1 * 10 ^ 18 wei
    // WEI = menor fração do padrão ETH
    uint balance;
    bool open;
}

contract FloodHelp {

    uint public lastId = 0;
    // Request[] public requests;
    mapping(uint => Request) public requests;

    function openRequest(
        string memory title,
        string memory description,
        string memory contact,
        uint goal
    ) public {
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
            open: true
        });
    }

    function closeRequest(uint id) public {
        address author = requests[id].author;
        uint balance = requests[id].balance;
        uint goal = requests[id].goal;
        require(requests[id].open && (msg.sender == author || balance >= goal), unicode"Você não pode fechar este pedido");

        requests[id].open = false;

        if (balance > 0) {
            requests[id].balance = 0;
            payable(author).transfer(balance);
        }
    }

    function donate(uint id) public payable {
        requests[id].balance += msg.value;
        if (requests[id].balance >= requests[id].goal) {
            closeRequest(id);
        }
    }

    function getOpenRequests (uint startId, uint quantity) public view returns(Request[] memory) {
        Request[] memory result = new Request[](quantity);
        uint id = startId;
        uint count = 0;

        do {
            if (requests[id].open) {
                result[count] = requests[id];
                count++;
            }
            id++;
        }
        while(count < quantity && id <= lastId);

        return result;
    }

}