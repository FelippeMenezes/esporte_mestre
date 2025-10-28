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

const TYPE_CONFIG = {
  success: { title: 'Sucesso', icon: 'success' },
  error: { title: 'Erro', icon: 'error' },
  info: { title: 'Informação', icon: 'info' }
}

export default class extends Controller {
  static values = { message: String, type: String }

  connect() {
    const config = TYPE_CONFIG[this.typeValue] || TYPE_CONFIG.info
    const formattedMessage = this.messageValue.replace(/\n/g, '<br>')

    Swal.fire({
      title: config.title,
      html: formattedMessage,
      icon: config.icon,
      confirmButtonText: "OK",
      confirmButtonColor: '#198754',
      toast: true,
      timer: 10000,
      showConfirmButton: true,
      customClass: SWAL_CLASSES
    })
  }
}