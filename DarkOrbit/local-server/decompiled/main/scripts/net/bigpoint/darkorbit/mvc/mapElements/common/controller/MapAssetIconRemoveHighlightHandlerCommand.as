package net.bigpoint.darkorbit.mvc.mapElements.common.controller
{
   import net.bigpoint.darkorbit.com.module.MapAssetIconRemoveHighlightCommand;
   import net.bigpoint.darkorbit.map.model.traits.clickIcon.ClickIconTrait;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class MapAssetIconRemoveHighlightHandlerCommand extends DOAbstractSimpleCommand
   {
      
      public function MapAssetIconRemoveHighlightHandlerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:MapAssetIconRemoveHighlightCommand = param1.getBody() as MapAssetIconRemoveHighlightCommand;
         var _loc3_:ClickIconTrait = screenManager.map.getEntityById(_loc2_.mapAssetId).getFirstTrait(ClickIconTrait) as ClickIconTrait;
         if(_loc3_)
         {
            _loc3_.highlight.value = false;
         }
      }
   }
}

