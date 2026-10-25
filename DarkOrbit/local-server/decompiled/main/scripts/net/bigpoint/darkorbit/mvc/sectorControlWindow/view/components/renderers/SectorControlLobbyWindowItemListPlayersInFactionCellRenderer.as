package net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.renderers
{
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.model.vo.SectorControlItemlistOverviewVO;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.SectorControlConstants;
   
   public class SectorControlLobbyWindowItemListPlayersInFactionCellRenderer extends SectorControlLobbyWindowItemListAbstractCellRenderer
   {
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function SectorControlLobbyWindowItemListPlayersInFactionCellRenderer()
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
      
      override public function set data(param1:Object) : void
      {
         var _loc3_:String = null;
         super.data = param1;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:SectorControlItemlistOverviewVO = param1 as SectorControlItemlistOverviewVO;
         if(_loc2_.playersOfOwnFaction < _loc2_.minPlayersPerTeam)
         {
            _loc3_ = SectorControlConstants.LOBBY_LABEL_COLOR_CRITICAL.toString(16);
         }
         else
         {
            _loc3_ = SectorControlConstants.LOBBY_LABEL_COLOR_CURRENTVALUE;
         }
         rowLabel.htmlText = "<font size=\'12\' color=\'#" + _loc3_ + "\'>" + _loc2_.playersOfOwnFaction.toString() + "</font>" + "<font size=\'12\' color=\'#" + SectorControlConstants.LOBBY_LABEL_COLOR_DEFAULTVALUE + "\'>/" + _loc2_.maxPlayersOfOwnFaction + "</font>";
         columnLabelContainer.toolTip = BPLocale.getItem("ttip_sectorcontrol_lobbywindow_remaining_players");
      }
   }
}

