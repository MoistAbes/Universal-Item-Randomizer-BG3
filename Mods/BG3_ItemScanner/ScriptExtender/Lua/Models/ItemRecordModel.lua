ULF_ItemRecordModel = {}

function ULF_ItemRecordModel.New(data)

    return {
        RootTemplate = data.RootTemplate,

        DisplayName = data.DisplayName,
        Icon = data.Icon,

        TemplateName = data.TemplateName,
        TemplateType = data.TemplateType,

        IsStoryItem = data.IsStoryItem,

        Stats = data.Stats or {}
    }

end