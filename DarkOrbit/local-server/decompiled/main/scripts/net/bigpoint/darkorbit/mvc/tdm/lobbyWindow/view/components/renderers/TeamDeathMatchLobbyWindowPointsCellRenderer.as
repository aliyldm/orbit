package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.components.renderers
{
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchOverviewModule;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.TeamDeathMatchLobbyWindowConstants;
   
   public class TeamDeathMatchLobbyWindowPointsCellRenderer extends TeamDeathMatchLobbyWindowAbstractCellRenderer
   {
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function TeamDeathMatchLobbyWindowPointsCellRenderer()
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
         columnLabelContainer.toolTip = BPLocale.getItem("ttip_teamdeathmatch_lobbywindow_column_icon_points");
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:String = TeamDeathMatchLobbyWindowConstants.LOBBY_LABEL_COLOR_CURRENTVALUE;
         var _loc3_:TeamDeathMatchOverviewModule = param1 as TeamDeathMatchOverviewModule;
         rowLabel.htmlText = "<font size=\'12\' color=\'#" + _loc2_ + "\'>" + _loc3_.pointsOfOwnTeam.toString() + "<b>  :  </b>" + _loc3_.pointsOfOpponentTeam.toString() + "</font>";
      }
   }
}

