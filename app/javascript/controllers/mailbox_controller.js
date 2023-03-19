import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["q", "from", "to", "mails", "pagination"]

  initialize() {
    this.intersectionObserver = new IntersectionObserver(
      entries => this.checkIntersection(entries),
      {
        rootMargin: '200px',
      }
    );
    this.page = 1;
  }

  connect() {
    this.fetchMails();
    this.intersectionObserver.observe(this.paginationTarget);
  }

  disconnect() {
    this.intersectionObserver.unobserve(this.paginationTarget);
  }

  checkIntersection(entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        this.page += 1;
        this.fetchMails();
      }
    })
  }

  search(event) {
    event.preventDefault();
    this.page = 1;
    this.fetchMails();
  }

  fetchMails() {
    fetch(`/api/mails/?q=${this.qTarget.value}&from_date=${this.fromTarget.value}&to_date=${this.toTarget.value}&page=${this.page}`, {
      headers: { accept: 'application/json'}
    })
    .then((response) => response.json())
    .then(data => {
      let template = "";
      data.items.forEach(mail => {
        template += this.templateFor(mail)
      });
      if (this.page === 1)
        this.mailsTarget.innerHTML = template;
      else
        this.mailsTarget.innerHTML += template;
   });
  }

  templateFor(mail) {
    return `
      <tr>
        <td>${mail.subject}</td>
        <td>${mail.sender}</td>
        <td>${mail.sent_at}</td>
      </tr>
    `
  }
}
