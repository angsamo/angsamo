const sidebar = document.querySelector("#sidebar");
const backdrop = document.querySelector("#sidebarBackdrop");

function setSidebar(open) {
	sidebar?.classList.toggle("open", open);
	backdrop?.classList.toggle("open", open);
}

document.querySelector("#menuButton")?.addEventListener("click", () => setSidebar(true));
backdrop?.addEventListener("click", () => setSidebar(false));

const notificationButton = document.querySelector("#notificationButton");
const notificationPanel = document.querySelector("#notificationPanel");

notificationButton?.addEventListener("click", (event) => {
	event.stopPropagation();
	notificationPanel?.classList.toggle("open");
});

document.addEventListener("click", (event) => {
	if (notificationPanel?.classList.contains("open") && !notificationPanel.contains(event.target)) {
		notificationPanel.classList.remove("open");
	}
});
