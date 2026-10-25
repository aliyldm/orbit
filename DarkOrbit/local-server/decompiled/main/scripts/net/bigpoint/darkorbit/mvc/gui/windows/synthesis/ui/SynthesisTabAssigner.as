package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.TabBarAssigner;
   
   public class SynthesisTabAssigner extends TabBarAssigner
   {
      
      private static const CANNON_START_GROUP:String = "cannonStarUp";
      
      private var _tabLabel:Label;
      
      public function SynthesisTabAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:String = null;
         super.data = param1;
         if(this._tabLabel)
         {
            _loc2_ = String(param1);
            this._tabLabel.text = _loc2_ == CANNON_START_GROUP ? "Cannon Start" : BPLocale.getItemInCategory("",_loc2_);
         }
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._tabLabel = FuiComponentSelectorUtil.selectComponent("tabLabel",this) as Label;
      }
   }
}

