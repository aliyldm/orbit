package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.items
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   
   public class TrinityTrialsDropInfoListItemRenderer extends DefaultItemDataAssigner
   {
      
      private var _label_1:Label;
      
      private var _label_2:Label;
      
      private var _label_3:Label;
      
      public function TrinityTrialsDropInfoListItemRenderer()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         this._label_1 = FuiComponentSelectorUtil.selectComponent("label_1",this) as Label;
         this._label_2 = FuiComponentSelectorUtil.selectComponent("label_2",this) as Label;
         this._label_3 = FuiComponentSelectorUtil.selectComponent("label_3",this) as Label;
      }
      
      override public function set data(param1:Object) : void
      {
         if(!param1)
         {
            return;
         }
         this._label_1.text = BPLocale.getItemInCategory("","trinitytrials_difficulty" + param1.param0);
         this._label_2.text = param1.param1;
         this._label_3.text = param1.param2;
      }
   }
}

