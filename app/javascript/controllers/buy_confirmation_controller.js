import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

export default class extends Controller {
  static values = {
    message: String
  }

  confirm(event) {
    event.preventDefault()

    Swal.fire({
      title: "Confirmação de Compra",
      text: this.messageValue,
      icon: "question",
      showDenyButton: true,
      showConfirmButton: true,
      confirmButtonText: "Sim, comprar!",
      denyButtonText: "Não, cancelar",
      confirmButtonColor: '#28a745',
      denyButtonColor: '#6c757d',
      toast: true,
      timer: 10000,
      customClass: {
        container: 'swal-container',
        popup: 'swal-popup',
        title: 'swal-title',
        htmlContainer: 'swal-text',
        icon: 'swal-icon',
        actions: 'swal-actions',
        confirmButton: 'swal-confirm-button',
        denyButton: 'swal-deny-button',
      }
    }).then((result) => {
      if (result.isConfirmed) {
        this.element.submit()
      } else if (result.isDenied) {
        Swal.fire({
          title: "Compra cancelada",
          text: "",
          icon: "info",
          confirmButtonColor: '#6c757d',
          toast: true,
          timer: 3000,
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
    })
  }
}