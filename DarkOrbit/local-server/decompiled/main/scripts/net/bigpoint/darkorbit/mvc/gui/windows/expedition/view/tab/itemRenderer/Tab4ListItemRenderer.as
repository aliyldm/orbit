package net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab.itemRenderer
{
   import flash.display.Shape;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.utils.time.TimeUtils;
   
   public class Tab4ListItemRenderer extends DefaultItemDataAssigner
   {
      
      private var self_bg:Coreponent;
      
      private var rank_label:Label;
      
      private var name_label:Label;
      
      private var level_label:Label;
      
      private var time_label:Label;
      
      private var bg:Shape = null;
      
      public function Tab4ListItemRenderer()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         this.self_bg = FuiComponentSelectorUtil.selectComponent("self_bg",this) as Coreponent;
         this.self_bg.visible = false;
         this.rank_label = FuiComponentSelectorUtil.selectComponent("rank_label",this) as Label;
         this.name_label = FuiComponentSelectorUtil.selectComponent("name_label",this) as Label;
         this.level_label = FuiComponentSelectorUtil.selectComponent("level_label",this) as Label;
         this.time_label = FuiComponentSelectorUtil.selectComponent("time_label",this) as Label;
      }
      
      override public function set data(param1:Object) : void
      {
         if(!param1)
         {
            this.clean();
            return;
         }
         if(!this.bg)
         {
            this.drawBg();
         }
         this.self_bg.visible = param1.userId == Hero.userID;
         this.rank_label.text = param1.rank;
         this.name_label.text = param1.userName;
         this.level_label.text = param1.curLevel;
         this.time_label.text = TimeUtils.formatTimeMinutes(param1.clearanceTime);
      }
      
      private function drawBg() : void
      {
         this.bg = new Shape();
         this.bg.graphics.beginFill(0,0.1);
         this.bg.graphics.drawRect(0,0,this.width,this.height);
         this.bg.graphics.endFill();
         this.addChild(this.bg);
      }
      
      private function clean() : void
      {
         if(this.bg)
         {
            this.bg.graphics.clear();
            this.removeChild(this.bg);
            this.bg = null;
         }
         this.self_bg.visible = false;
         this.rank_label.text = "";
         this.name_label.text = "";
         this.level_label.text = "";
         this.time_label.text = "";
      }
   }
}

