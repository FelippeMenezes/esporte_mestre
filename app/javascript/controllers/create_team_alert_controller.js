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

const TEAM_CREATION_INFO = `
  <ul style="text-align: left;">
    <li>Uma nova campanha será criada exclusivamente para você</li>
    <li>9 times rivais serão gerados automaticamente</li>
    <li>Cada time (incluindo o seu) receberá 15 jogadores</li>
    <li>Você começará com um orçamento de $500.000</li>
  </ul>
`

export default class extends Controller {
  connect() {
    Swal.fire({
      title: "O que acontece quando você cria um time:",
      html: TEAM_CREATION_INFO,
      icon: "info",
      confirmButtonText: "Entendi",
      confirmButtonColor: '#198754',
      toast: true,
      timer: 15000,
      showConfirmButton: true,
      customClass: SWAL_CLASSES
    })
  }
}