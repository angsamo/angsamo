const sidebar = document.querySelector("#sidebar");
const backdrop = document.querySelector("#sidebarBackdrop");

function setSidebar(open) {
	sidebar?.classList.toggle("open", open);
	backdrop?.classList.toggle("open", open);
}

document.querySelector("#menuButton")?.addEventListener("click", () => setSidebar(true));
backdrop?.addEventListener("click", () => setSidebar(false));
