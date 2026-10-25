package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.main.view
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   
   public class SeasonPassUITabBarAssigner extends DefaultItemDataAssigner
   {
      
      private var _tabLabel:Label;
      
      private var _tab:Button;
      
      private var _tabSelected:Button;
      
      public function SeasonPassUITabBarAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         var _loc2_:String = String(param1);
         this._tabLabel.text = BPLocale.getItem(_loc2_);
         this.drawSelection();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._tabLabel = FuiComponentSelectorUtil.selectComponent("tabLabel",this) as Label;
         this._tabSelected = FuiComponentSelectorUtil.selectComponent("tab_selected",this) as Button;
         this._tab = FuiComponentSelectorUtil.selectComponent("tab",this) as Button;
      }
      
      override protected function drawSelection() : void
      {
         if(_selected)
         {
            this._tab.visible = false;
            this._tabSelected.visible = true;
            this._tabLabel.registeredTextStyleName = "season_pass_tab_selected_center";
         }
         else
         {
            this._tab.visible = true;
            this._tabSelected.visible = false;
            this._tabLabel.registeredTextStyleName = "season_pass_tab_center";
         }
         super.drawSelection();
      }
      
      override public function set index(param1:int) : void
      {
         this._tab.registeredSkinName = "commonui_tabbarbutton";
         this._tabSelected.registeredSkinName = "commonui_tabbarbutton.selected";
         super.index = param1;
      }
   }
}

