import Footer from "@/components/Footer";
import Header from "@/components/Header";

export default function Home() {
  return (
    <>
      <Header />
      <div className="container">
        <div className="ps-5">
          <div className="row my-3">
            <p className="lead">Preencha todos os campos abaixo para nos dizer o que precisa:</p>
          </div>
          <div className="col-6">
            <div className="form-floating mb-3">
              <input type="text" id="title" className="form-control" maxLength={150} />
              <label htmlFor="title">Resumo do que precisa:</label>
            </div>
          </div>
          <div className="col-6">
            <div className="form-floating mb-3">
              <textarea id="description" className="form-control" style={{ height: 100 }}></textarea>
              <label htmlFor="description">Descreva em detalhes o que precisa e onde você está &#40;para entregas presenciais&#41;:</label>
            </div>
          </div>
          <div className="col-6">
            <div className="form-floating mb-3">
              <input type="text" id="contact" className="form-control" maxLength={150} />
              <label htmlFor="contact">Contato &#40;Telefone ou e-mail&#41;:</label>
            </div>
          </div>
          <div className="col-6">
            <div className="form-floating mb-3">
              <input type="number" inputmode="numeric" id="goal" className="form-control" />
              <label htmlFor="goal">Meta em BNB &#40;Deixe em branco caso não deseje receber doação em cripto&#41;:</label>
            </div>
          </div>
          <div className="row">
            <div className="col-1 mb-3">
              <a href="/" className="btn btn-outline-dark col-12 p-3">Voltar</a>
            </div>
            <div className="col-5 mb-3 p-0">
              <button type="button" className="btn btn-dark col-12 p-3">Enviar Pedido</button>
            </div>
          </div>
        </div>
        <Footer />
      </div>
    </>
  );
}
