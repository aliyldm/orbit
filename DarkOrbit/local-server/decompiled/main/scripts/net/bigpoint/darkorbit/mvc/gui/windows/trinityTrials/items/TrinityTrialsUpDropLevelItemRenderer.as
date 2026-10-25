package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.items
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.DropLevelVo;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   
   public class TrinityTrialsUpDropLevelItemRenderer extends DefaultItemDataAssigner
   {
      
      private var _level_info:Label;
      
      private var _bg:Coreponent;
      
      private var _current_level_desc:Label;
      
      private var itemData:DropLevelVo;
      
      public function TrinityTrialsUpDropLevelItemRenderer()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         this._level_info = this.getChildByName("level_info") as Label;
         var _loc1_:Coreponent = this.getChildByName("current_level") as Coreponent;
         this._current_level_desc = _loc1_.getChildByName("current_level_desc") as Label;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(!param1)
         {
            return;
         }
         this.itemData = param1 as DropLevelVo;
         if(this._level_info)
         {
            this._level_info.text = BPLocale.getItemInCategory("","trinitytrials_upgrade_quality_" + this.itemData.level);
            this._current_level_desc.useHTML = false;
            this._current_level_desc.text = this.itemData.value + "%";
         }
         else
         {
            _loc2_ = this.itemData.value + "%";
            _loc3_ = HtmlTextUtils.coloriseText(65280,_loc2_);
            this._current_level_desc.useHTML = true;
            this._current_level_desc.text = _loc3_;
         }
      }
   }
}

