constants = {}

function constants.load()

    GUI_BUTTONS = {}
    FONT = {}
    PHYSOBJECTS = {}
    IMAGES = {}
    ARROWS = {}
    RESULTS = {}
    GRAPH = {}

    BOX2D_SCALE = 20
    ARROW_TIMER = 30        -- seconds before destruction. NOT used on phys object. Used on image.


    enum = {}
    enum.sceneMainMenu = 1
    enum.sceneRange = 2

    enum.buttonStart = 1

    enum.fontDefault = 1

    enum.physObjGround = 1
    enum.physObjTarget = 2
    enum.physObjArrow = 3

    enum.imagesArrow = 1

end



return constants
