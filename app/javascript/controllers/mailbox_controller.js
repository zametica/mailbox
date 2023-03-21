import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["q", "from", "to", "mails", "pagination"]

  initialize() {
    this.authorize();
    this.intersectionObserver = new IntersectionObserver(
      entries => this.checkIntersection(entries),
      {
        rootMargin: '200px',
      }
    );
    this.page = 1;
  }

  connect() {
    if (window.localStorage.getItem('access_token')) {
      this.fetchMails();
      this.intersectionObserver.observe(this.paginationTarget);
    }
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
      headers: {
        accept: 'application/json',
        authorization: window.localStorage.getItem('access_token'),
        id: window.localStorage.getItem('id_token')
      }
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

  authorize() {
    if (window.localStorage.getItem('access_token')) return;

    google.accounts.oauth2.initCodeClient({
      client_id: "185620065380-mqk3ea3kjv0pd2soq0dqfulop0mpig4d.apps.googleusercontent.com",
      scope: 'https://www.googleapis.com/auth/gmail.readonly',
      prompt: 'consent',
      redirect_uri: 'http://localhost:3000/api/auth',
      callback: (response) => {
        fetch(`/api/auth?code=${response.code}`, {
          headers: {
            accept: 'application/json',
          }
        })
          .then((response) => response.json())
          .then(data => {
            if (data.access_token) {
              window.localStorage.setItem('access_token', data.access_token);
              window.localStorage.setItem('refresh_token', data.refresh_token);
              window.localStorage.setItem('id_token', data.id_token);
              this.fetchMails();
            }
          });
      }
    }).requestCode();
  }
}
