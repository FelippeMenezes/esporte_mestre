import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

export default class extends Controller {
  static values = { message: String, type: String }

  connect() {
    const type = this.typeValue || 'info'
    const icon = type === 'success' ? 'success' : type === 'error' ? 'error' : 'info'
    const formattedMessage = this.messageValue.replace(/\n/g, '<br>')

    Swal.fire({
      title: type === 'success' ? 'Sucesso' : type === 'info' ? 'Informação' : 'Erro',
      html: formattedMessage,
      icon: icon,
      confirmButtonText: "OK",
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