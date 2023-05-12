Array.from(document.getElementsByClassName('spoiler-show')).forEach((element) => {
    element.addEventListener("click", (event) => {
        event.target.parentElement.parentElement.classList.remove("sensitive");
        event.target.style.display = "none";
    });
});
