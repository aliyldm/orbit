package net.bigpoint.darkorbit.net.netty.handlers.assets
{
   import net.bigpoint.darkorbit.com.module.InstantRepairAssetInformationModule;
   import net.bigpoint.darkorbit.com.module.MapAssetActionAvailableCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.map.model.traits.clickIcon.ClickIconTrait;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.anniv19.DifficultySelectionNotification;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.TrinityTrialsConst;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class AssetActionAvailableHandler extends DOAbstractSimpleCommand
   {
      
      public function AssetActionAvailableHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:ClickIconTrait = null;
         var _loc4_:SimpleWindow = null;
         var _loc2_:MapAssetActionAvailableCommand = param1.getBody() as MapAssetActionAvailableCommand;
         if(screenManager.map)
         {
            _loc3_ = screenManager.map.getTraitById(_loc2_.mapAssetId,ClickIconTrait) as ClickIconTrait;
            if(_loc3_)
            {
               if(_loc2_.toolTip.commandList.length > 0 && !_loc2_.activatable)
               {
                  if(_loc2_.toolTip.commandList[0].baseKey == "ttip_jumpgate_bday2025")
                  {
                     GameFacade.getInstance().sendNotification(DifficultySelectionNotification.CLOSE_WINDOW);
                  }
                  if(_loc2_.toolTip.commandList[0].baseKey == "ttip_jumpgate_trinitytrials")
                  {
                     _loc4_ = guiManager.getWindow(TrinityTrialsConst.DIFFICULTY_SELECT);
                     (_loc4_) && _loc4_.minimize();
                  }
                  if(_loc2_.toolTip.commandList[0].baseKey == "ttip_jumpgate_voyagersascentrial")
                  {
                     _loc4_ = guiManager.getWindow(GuiConstants.SINGULARITYDRIVE_DIFFICULTY_SELECT);
                     (_loc4_) && _loc4_.minimize();
                  }
               }
               _loc3_.handleActionAvailableCommand(_loc2_.activatable && _loc2_.state == MapAssetActionAvailableCommand.AVAILABILITYSTATE_ON,TextUtils.getTooltipText(_loc2_.toolTip,true));
               if(_loc2_.additionalInformation != null && _loc2_.additionalInformation is InstantRepairAssetInformationModule)
               {
                  _loc3_.text.value = (_loc2_.additionalInformation as InstantRepairAssetInformationModule).instantRepairCount.toString();
               }
            }
         }
      }
   }
}

