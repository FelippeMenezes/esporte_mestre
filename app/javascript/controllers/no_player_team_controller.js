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
    Swal.fire({
      title: "Você não tem jogadores no seu time:",
      text: "Contrate pelo menos 11 jogadores para o seu time ficar habilitado a jogar partidas.",
      icon: "warning",
      confirmButtonText: "Entendi",
      confirmButtonColor: '#198754',
      toast: true,
      timer: 15000,
      showConfirmButton: true,
      customClass: SWAL_CLASSES
    })
  }
}