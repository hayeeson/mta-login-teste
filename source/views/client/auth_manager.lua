addEventHandler("onClientRender", root, function()
    if not UI_STATE.visible then
        return
    end

    drawBackgroundGeneral()
    UpdateUITransition()
    CreateLoginUI()
    CreateRegisterUI()
    CreateRecoveryUI()
end)