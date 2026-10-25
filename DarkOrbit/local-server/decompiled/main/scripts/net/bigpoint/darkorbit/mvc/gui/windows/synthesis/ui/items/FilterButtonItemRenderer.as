package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items
{
   import com.greensock.TweenLite;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.vo.FilterButtonVo;
   
   public class FilterButtonItemRenderer extends DefaultItemDataAssigner
   {
      
      private static const SECONDARY_ANIMATION_DURATION:Number = 0.18;
      
      private var _filter_btn:Button;
      
      private var _select_btn:Coreponent;
      
      private var _normal_btn:Coreponent;
      
      private var _btnLabel:Label;
      
      private var _secondarySelectButton:Coreponent;
      
      private var _secondaryNormalButton:Coreponent;
      
      private var _secondaryLabel:Label;
      
      private var _filterData:FilterButtonVo;
      
      private var _primarySelectButtonX:Number;
      
      private var _primarySelectButtonY:Number;
      
      private var _primaryNormalButtonX:Number;
      
      private var _primaryNormalButtonY:Number;
      
      private var _primaryLabelX:Number;
      
      private var _primaryLabelY:Number;
      
      private var _secondarySelectButtonX:Number;
      
      private var _secondarySelectButtonY:Number;
      
      private var _secondaryNormalButtonX:Number;
      
      private var _secondaryNormalButtonY:Number;
      
      private var _secondaryLabelX:Number;
      
      private var _secondaryLabelY:Number;
      
      public function FilterButtonItemRenderer()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc3_:String = null;
         this._filterData = param1 as FilterButtonVo;
         this.resetAnimationState();
         super.data = param1;
         if(!param1)
         {
            this.drawSelection();
            this.visible = false;
            return;
         }
         this.visible = true;
         var _loc2_:FilterButtonVo = this._filterData;
         _loc3_ = BPLocale.getItemInCategory("",param1.type_name);
         if(Boolean(_loc2_) && _loc2_.isSecondary)
         {
            this._secondaryLabel.text = _loc3_;
         }
         else
         {
            this._btnLabel.text = _loc3_;
         }
         this.drawSelection();
         if(Boolean(_loc2_) && Boolean(_loc2_.isSecondary) && _loc2_.animateIn)
         {
            this.animateSecondaryIn();
            _loc2_.animateIn = false;
         }
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._select_btn = FuiComponentSelectorUtil.selectComponent("select_btn",this) as Coreponent;
         this._normal_btn = FuiComponentSelectorUtil.selectComponent("normal_btn",this) as Coreponent;
         this._btnLabel = FuiComponentSelectorUtil.selectComponent("cannon_type_name",this) as Label;
         this._secondarySelectButton = FuiComponentSelectorUtil.selectComponent("secondary_select_btn",this) as Coreponent;
         this._secondaryNormalButton = FuiComponentSelectorUtil.selectComponent("secondary_normal_btn",this) as Coreponent;
         this._secondaryLabel = FuiComponentSelectorUtil.selectComponent("secondary_label",this) as Label;
         this._primarySelectButtonX = this._select_btn.x;
         this._primarySelectButtonY = this._select_btn.y;
         this._primaryNormalButtonX = this._normal_btn.x;
         this._primaryNormalButtonY = this._normal_btn.y;
         this._primaryLabelX = this._btnLabel.x;
         this._primaryLabelY = this._btnLabel.y;
         this._secondarySelectButtonX = this._secondarySelectButton.x;
         this._secondarySelectButtonY = this._secondarySelectButton.y;
         this._secondaryNormalButtonX = this._secondaryNormalButton.x;
         this._secondaryNormalButtonY = this._secondaryNormalButton.y;
         this._secondaryLabelX = this._secondaryLabel.x;
         this._secondaryLabelY = this._secondaryLabel.y;
         this._select_btn.visible = false;
         this._normal_btn.visible = true;
         this._secondarySelectButton.visible = false;
         this._secondaryNormalButton.visible = false;
         this._secondaryLabel.visible = false;
      }
      
      private function resetAnimationState() : void
      {
         TweenLite.killTweensOf(this);
         this.alpha = 1;
         this.scaleX = 1;
         this.scaleY = 1;
         this.resetVisualState(this._select_btn,this._primarySelectButtonX,this._primarySelectButtonY);
         this.resetVisualState(this._normal_btn,this._primaryNormalButtonX,this._primaryNormalButtonY);
         this.resetVisualState(this._btnLabel,this._primaryLabelX,this._primaryLabelY);
         this.resetVisualState(this._secondarySelectButton,this._secondarySelectButtonX,this._secondarySelectButtonY);
         this.resetVisualState(this._secondaryNormalButton,this._secondaryNormalButtonX,this._secondaryNormalButtonY);
         this.resetVisualState(this._secondaryLabel,this._secondaryLabelX,this._secondaryLabelY);
      }
      
      private function resetVisualState(param1:*, param2:Number, param3:Number) : void
      {
         if(!param1)
         {
            return;
         }
         TweenLite.killTweensOf(param1);
         param1.x = param2;
         param1.y = param3;
         param1.alpha = 1;
         param1.scaleX = 1;
         param1.scaleY = 1;
      }
      
      private function animateSecondaryIn() : void
      {
         TweenLite.killTweensOf(this);
         this.alpha = 0;
         TweenLite.to(this,SECONDARY_ANIMATION_DURATION,{"alpha":1});
      }
      
      override protected function drawSelection() : void
      {
         var _loc1_:Boolean = this._filterData != null && this._filterData.isSecondary;
         var _loc2_:Boolean = this.isSelected() || this._filterData != null && this._filterData.active;
         if(this._select_btn)
         {
            this._select_btn.visible = !_loc1_ && _loc2_;
         }
         if(this._normal_btn)
         {
            this._normal_btn.visible = !_loc1_ && !_loc2_;
         }
         if(this._btnLabel)
         {
            this._btnLabel.visible = !_loc1_;
         }
         if(this._secondarySelectButton)
         {
            this._secondarySelectButton.visible = _loc1_ && _loc2_;
         }
         if(this._secondaryNormalButton)
         {
            this._secondaryNormalButton.visible = _loc1_ && !_loc2_;
         }
         if(this._secondaryLabel)
         {
            this._secondaryLabel.visible = _loc1_;
         }
      }
   }
}

