import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

const SWAL_CLASSES = {
  container: 'swal-container',
  popup: 'swal-popup',
  title: 'swal-title',
  htmlContainer: 'swal-text',
  icon: 'swal-icon',
  actions: 'swal-actions',
  confirmButton: 'swal-confirm-button',
}

export default class extends Controller {
  connect() {
    const newMatchPath = this.element.dataset.noMatchesNewMatchPath
    Swal.fire({
      title: "Nenhuma partida encontrada",
      html: `Seu time ainda não jogou nenhuma partida.<br> <a href="${newMatchPath}">Criar uma nova partida</a> agora!`,
      icon: "info",
      confirmButtonText: "Entendi",
      confirmButtonColor: '#198754',
      toast: true,
      timer: 10000,
      showConfirmButton: true,
      customClass: SWAL_CLASSES
    })
  }
}