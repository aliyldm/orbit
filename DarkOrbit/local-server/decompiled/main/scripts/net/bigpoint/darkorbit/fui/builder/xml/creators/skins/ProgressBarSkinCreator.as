package net.bigpoint.darkorbit.fui.builder.xml.creators.skins
{
   import net.bigpoint.darkorbit.fui.components.bars.skins.ProgressBarSkin;
   import net.bigpoint.darkorbit.fui.components.core.skins.ISkin;
   
   public class ProgressBarSkinCreator extends AbstractSkinCreator
   {
      
      public function ProgressBarSkinCreator()
      {
         super();
      }
      
      override public function create(param1:XML) : ISkin
      {
         var _loc2_:ISkin = new ProgressBarSkin();
         (_loc2_ as ProgressBarSkin).tweenTime = param1.attribute("tweenTime").length() > 0 ? Number(param1.attribute("tweenTime")) : 0;
         assignSkinStates(param1,_loc2_);
         return _loc2_;
      }
   }
}

