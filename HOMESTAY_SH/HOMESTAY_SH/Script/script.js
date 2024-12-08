document.addEventListener('DOMContentLoaded', function () {
    function initializeCircularSlider(sliderContentSelector, prevButtonSelector, nextButtonSelector, slideSelector, visibleSlides, slideWidth) {
        const sliderContent = document.querySelector(sliderContentSelector);
        const prevButton = document.querySelector(prevButtonSelector);
        const nextButton = document.querySelector(nextButtonSelector);
        const slides = document.querySelectorAll(slideSelector);

        if (sliderContent && prevButton && nextButton && slides.length) {
            // Calculate initial position and determine transition state
            let currentPosition = -slideWidth * visibleSlides;
            let isTransitioning = false;

            // Clone the first and last slides for a circular effect
            const firstClones = Array.from(slides).slice(0, visibleSlides).map(slide => slide.cloneNode(true));
            const lastClones = Array.from(slides).slice(-visibleSlides).map(slide => slide.cloneNode(true));

            // Append clones to the slider content
            firstClones.forEach(clone => sliderContent.appendChild(clone));
            lastClones.forEach(clone => sliderContent.insertBefore(clone, sliderContent.firstChild));

            // Set initial transform position to include left clones
            sliderContent.style.transform = `translateX(${currentPosition}px)`;

            // Update slider position with transition effect
            function updateSliderPosition() {
                sliderContent.style.transition = 'transform 0.3s ease-in-out';
                sliderContent.style.transform = `translateX(${currentPosition}px)`;
            }

            // Jump back to original position without transition for smooth looping
            function jumpWithoutTransition(position) {
                sliderContent.style.transition = 'none';
                sliderContent.style.transform = `translateX(${position}px)`;
            }

            // Next button click handler
            nextButton.addEventListener('click', () => {
                if (isTransitioning) return;
                isTransitioning = true;

                currentPosition -= slideWidth;
                updateSliderPosition();

                // Check if we've reached the cloned slides on the right
                sliderContent.addEventListener('transitionend', () => {
                    if (currentPosition <= -(slideWidth * (slides.length + visibleSlides))) {
                        currentPosition = -slideWidth * visibleSlides; // Reset to the real first slide
                        jumpWithoutTransition(currentPosition);
                    }
                    isTransitioning = false;
                }, { once: true });
            });

            // Previous button click handler
            prevButton.addEventListener('click', () => {
                if (isTransitioning) return;
                isTransitioning = true;

                currentPosition += slideWidth;
                updateSliderPosition();

                // Check if we've reached the cloned slides on the left
                sliderContent.addEventListener('transitionend', () => {
                    if (currentPosition >= 0) {
                        currentPosition = -slideWidth * slides.length; // Reset to the real last slide
                        jumpWithoutTransition(currentPosition);
                    }
                    isTransitioning = false;
                }, { once: true });
            });
        } else {
            console.error(`Slider elements not found for selectors: ${sliderContentSelector}, ${prevButtonSelector}, ${nextButtonSelector}, ${slideSelector}`);
        }
    }

    // Initialize each slider with specific parameters
    initializeCircularSlider('.slider-content', '.image-wrapper', '.img-wrapper', '.overlap-group-wrapper-3', 4, 361); // Slider 1
    initializeCircularSlider('.slider-content1', '.btn-left', '.btn-right', '.overlap-group-wrapper', 2, 748); // Slider 2
    initializeCircularSlider('.slider-content2', '.btn-left1', '.btn-right1', '.overlap-group-wrapper', 2, 748); // Slider 3
    initializeCircularSlider('.slider-content3', '.button-left', '.button-right', '.overlap-group-wrapper-2', 3, 461); // Slider 4
});