package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.components.renderers
{
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchOverviewModule;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.TeamDeathMatchLobbyWindowConstants;
   
   public class TeamDeathMatchLobbyWindowPlayersCellRenderer extends TeamDeathMatchLobbyWindowAbstractCellRenderer
   {
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function TeamDeathMatchLobbyWindowPlayersCellRenderer()
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
      
      override protected function createChildren() : void
      {
         super.createChildren();
         columnLabelContainer.toolTip = BPLocale.getItem("ttip_teamdeathmatch_lobbywindow_column_icon_amount_of_players");
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:String = TeamDeathMatchLobbyWindowConstants.LOBBY_LABEL_COLOR_CURRENTVALUE;
         var _loc3_:String = TeamDeathMatchLobbyWindowConstants.LOBBY_LABEL_COLOR_DEFAULTVALUE;
         var _loc4_:TeamDeathMatchOverviewModule = param1 as TeamDeathMatchOverviewModule;
         rowLabel.htmlText = "<font size=\'12\' color=\'#" + _loc2_ + "\'>" + _loc4_.playersInOwnTeam.toString() + "</font>" + "<font size=\'12\' color=\'#" + _loc3_ + "\'>" + "/" + _loc4_.maxPlayerPerTeam.toString() + "</font>";
      }
   }
}

