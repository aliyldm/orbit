package net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.renderers
{
   import mx.core.IFlexModuleFactory;
   import mx.events.FlexEvent;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.model.vo.SectorControlItemlistOverviewVO;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.SectorControlConstants;
   
   public class SectorControlLobbyWindowItemListPlayersInQueueCellRenderer extends SectorControlLobbyWindowItemListAbstractCellRenderer
   {
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function SectorControlLobbyWindowItemListPlayersInQueueCellRenderer()
      {
         super();
         mx_internal::_document = this;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      override protected function creationCompleteHandler(param1:FlexEvent) : void
      {
         super.creationCompleteHandler(param1);
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:SectorControlItemlistOverviewVO = param1 as SectorControlItemlistOverviewVO;
         if(_loc2_.playersInQueue > 0)
         {
            rowLabel.htmlText = "<font size=\'12\' color=\'#" + SectorControlConstants.LOBBY_LABEL_COLOR_CURRENTVALUE + "\'>" + _loc2_.playersInQueue.toString() + "</font>";
         }
         else
         {
            rowLabel.htmlText = "";
         }
      }
   }
}

