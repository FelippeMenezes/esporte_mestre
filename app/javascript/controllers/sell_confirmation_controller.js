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
  denyButton: 'swal-deny-button',
}

export default class extends Controller {
  static values = { message: String }

  confirm(event) {
    event.preventDefault()

    Swal.fire({
      title: "Confirmação de Venda",
      text: this.messageValue,
      icon: "warning",
      showDenyButton: true,
      confirmButtonText: "Sim, vender!",
      denyButtonText: "Não, cancelar",
      confirmButtonColor: '#d33',
      denyButtonColor: '#6c757d',
      toast: true,
      timer: 10000,
      customClass: SWAL_CLASSES
    }).then((result) => {
      if (result.isConfirmed) {
        this.element.submit()
      } else if (result.isDenied) {
        this.showCancellationAlert("Venda cancelada")
      }
    })
  }

  showCancellationAlert(title) {
    Swal.fire({
      title,
      text: "",
      icon: "info",
      confirmButtonColor: '#6c757d',
      toast: true,
      timer: 3000,
      customClass: {
        container: SWAL_CLASSES.container,
        popup: SWAL_CLASSES.popup,
        title: SWAL_CLASSES.title,
        htmlContainer: SWAL_CLASSES.htmlContainer,
        icon: SWAL_CLASSES.icon,
        actions: SWAL_CLASSES.actions,
        confirmButton: SWAL_CLASSES.confirmButton,
      }
    })
  }
}