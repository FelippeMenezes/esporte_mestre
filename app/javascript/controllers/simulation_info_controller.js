import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

export default class extends Controller {
  connect() {
    Swal.fire({
      title: "Como funciona a simulação:",
      html: `
        <ul style="text-align: left;">
          <li>O resultado é calculado baseado no nível médio dos jogadores</li>
          <li>Há um fator aleatório para tornar o jogo mais emocionante</li>
          <li>A partida será jogada automaticamente quando você confirmar</li>
        </ul>
      `,
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