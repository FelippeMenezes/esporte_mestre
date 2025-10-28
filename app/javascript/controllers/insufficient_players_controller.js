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
  static values = { teamPlayersPath: String, teamMarketPath: String, totalPlayers: Number }

  connect() {
    Swal.fire({
      title: "Não é possível jogar uma partida!",
      html: `Seu time precisa ter pelo menos 11 jogadores para jogar uma partida. Atualmente você tem ${this.totalPlayersValue} jogadores.<br><br><a href="${this.teamPlayersPathValue}" class="btn btn-primary">Ver Jogadores</a> <a href="${this.teamMarketPathValue}" class="btn btn-success">Ir ao Mercado</a>`,
      icon: "warning",
      confirmButtonText: "Fechar",
      confirmButtonColor: '#dc3545',
      showConfirmButton: true,
      toast: true,
      customClass: SWAL_CLASSES
    })
  }
}