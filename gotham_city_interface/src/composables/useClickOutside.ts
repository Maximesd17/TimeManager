import { onBeforeUnmount, onMounted, type Ref } from "vue";

export default function useDetectOutsideClick(
	component: Ref<any> | Ref<any>[],
	callback: Function,
	ignore: string[] = []
) {
	if (!component) return;

	function listener(event: MouseEvent) {
		console.log('listener');
		const origins = (component instanceof Array ? component : [component])
			.map(origin => origin.value?.$el || origin.value)
			.filter(Boolean);

		if (origins.length === 0) return;

		const target = event.target as Element;
		if (origins.some(origin => origin.contains(target))) return;
		if (target?.closest && ignore.some(ignored => target.closest(ignored))) return;

		if (typeof callback === 'function') callback();
	}

	onMounted(() => {
		document.addEventListener('click', listener);
	});
	onBeforeUnmount(() => {
		document.removeEventListener('click', listener);
	});

	return { listener };
}

export function useDragOutside(component: Ref<any> | Ref<any>[], callback: Function, ignore: string[] = []) {
	if (!component) return;

	function listener(event: TouchEvent) {
		const origins = (component instanceof Array ? component : [component])
			.map(origin => origin.value?.$el || origin.value)
			.filter(Boolean);

		if (origins.length === 0) return;

		const target = event.target as Element;
		if (origins.some(origin => origin.contains(target))) return;
		if (target?.closest && ignore.some(ignored => target.closest(ignored))) return;

		if (typeof callback === 'function') callback();
	}

	onMounted(() => {
		window.addEventListener('touchstart', listener);
	});
	onBeforeUnmount(() => {
		window.removeEventListener('touchstart', listener);
	});

	return { listener };
}
