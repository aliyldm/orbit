package net.bigpoint.darkorbit.fui.components.tooltip
{
   import com.bigpoint.utils.bindables.BindableString;
   
   public class BindableStringToolTipAssigner extends DefaultTooltipDataAssigner
   {
      
      public function BindableStringToolTipAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:BindableString = _data as BindableString;
         if(_loc2_)
         {
            _loc2_.changed.remove(this.assign);
         }
         super.data = param1;
         _loc2_ = _data as BindableString;
         if(_loc2_)
         {
            _loc2_.changed.add(this.assign);
         }
      }
      
      override public function assign() : void
      {
         var _loc1_:BindableString = _data as BindableString;
         if(_loc1_)
         {
            setLabelText(_loc1_.value);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.data = null;
      }
   }
}

