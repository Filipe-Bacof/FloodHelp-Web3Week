"use client"

import { useEffect, useState } from "react";
import Footer from "@/components/Footer";
import Header from "@/components/Header";
import { getOpenRequests } from "@/services/Web3Service";
import Request from "@/components/Request";

export default function Home() {

  const [requests, setRequests] = useState([]);
  const [lastId, setLastId] = useState(0);

  useEffect(() => {
    loadRequests(lastId)
  }, [lastId])

  async function loadRequests(lastId){
    try {
      const result = await getOpenRequests(lastId)
      // console.log(result)
      if (lastId === 0) {
        setRequests(result);
      } else {
        setRequests(oldState => [...oldState, ...result])
      }
    } catch (err) {
      console.error(err);
      alert(err.message);
    }
  }

  function btnLoadMoreClick () {
    setLastId(Number(requests[requests.length - 1].id));
  }

  return (
    <>
      <Header />
      <div className="container">
        <div className="row ps-5">
          <p className="lead m-4">Ajude as vítimas de enchentes e demais desastres naturais do Brasil</p>
        </div>
        <div className="p-4 mx-5">
          <div className="list-group">
            {requests && requests.length ? 
              requests.map((item) => <Request key={item.id} data={item} />)
            : 
              <>Conecte sua carteira MetaMask no botão "Entrar" para ajudar ou pedir ajuda.</>
            }
          </div>
          {requests && requests.length && requests.length % 2 === 0 ? (
              <div className="mt-3 text-center">
                <button type="button" onClick={btnLoadMoreClick} className="btn btn-outline-dark btn-lg">Mostrar mais Resultados</button>
              </div>
            ) : (
              <></>
            )}
        </div>
        <Footer />
      </div>
    </>
  );
}
