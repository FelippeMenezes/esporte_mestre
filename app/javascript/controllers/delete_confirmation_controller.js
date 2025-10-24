import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

export default class extends Controller {
  confirm(event) {
    event.preventDefault()

    Swal.fire({
      title: "Você não poderá reverter isso!",
      text: "Tem certeza?",
      icon: "warning",
      showDenyButton: true,
      confirmButtonText: "Sim, deletar!",
      denyButtonText: "Não deletar",
      confirmButtonColor: '#d33',
      denyButtonColor: '#198754',
      toast: true,
      timer: 10000,
      showConfirmButton: true,
      showDenyButton: true,
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
          title: "Ação cancelada",
          text: "",
          icon: "info",
          confirmButtonColor: '#198754',
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