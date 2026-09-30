local PAGE_ORDER = {
    login = 1,
    register = 2,
    recovery = 3,
}

UI_STATE = {
    page = "login";
    previousPage = nil;
    transitioning = false;
    transitionStart = 0;
    transitionDuration = 280;
    direction = 1;
    visible = true;
}

function SetUIPage(page)
    if not PAGE_ORDER[page] then
        outputDebugString("SetUIPage: página inválida '" .. tostring(page) .. "'")
        return
    end

    if UI_STATE.page == page or UI_STATE.transitioning then
        return
    end

    UI_STATE.direction = (PAGE_ORDER[page] > PAGE_ORDER[UI_STATE.page]) and 1 or -1
    UI_STATE.previousPage = UI_STATE.page
    UI_STATE.page = page
    UI_STATE.transitionStart = getTickCount()
    UI_STATE.transitioning = true
end

function UpdateUITransition()
    if not UI_STATE.transitioning then
        return
    end

    if getTickCount() - UI_STATE.transitionStart >= UI_STATE.transitionDuration then
        UI_STATE.transitioning = false
        UI_STATE.previousPage = nil
    end
end

function GetPageTransitionOffset(pageName)
    if not UI_STATE.transitioning then
        return 0, pageName == UI_STATE.page
    end

    if pageName ~= UI_STATE.page and pageName ~= UI_STATE.previousPage then
        return 0, false
    end

    local elapsed = getTickCount() - UI_STATE.transitionStart
    local t = math.min(elapsed / UI_STATE.transitionDuration, 1)
    local eased = easeOutQuad(t)
    local screenW = GetScreenSize()

    if pageName == UI_STATE.page then
        return UI_STATE.direction * screenW * (1 - eased), true
    end

    return -UI_STATE.direction * screenW * eased, true
end