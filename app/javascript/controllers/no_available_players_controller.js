import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

export default class extends Controller {
  connect() {
    Swal.fire({
      title: "Mercado de Transferências",
      text: "Nenhum jogador disponível para compra no momento.",
      icon: "info",
      confirmButtonText: "Entendi",
      confirmButtonColor: '#198754',
      toast: true,
      timer: 10000,
      showConfirmButton: true,
      customClass: {
        container: 'swal-container',
        popup: 'swal-popup',
        title: 'swal-title',
        htmlContainer: 'swal-text',
        icon: 'swal-icon',
        actions: 'swal-actions',
        confirmButton: 'swal-confirm-button',
      }
    });
  }
}