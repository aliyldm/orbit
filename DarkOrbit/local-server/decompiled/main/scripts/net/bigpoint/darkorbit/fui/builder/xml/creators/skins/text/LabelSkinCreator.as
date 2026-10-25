package net.bigpoint.darkorbit.fui.builder.xml.creators.skins.text
{
   import net.bigpoint.darkorbit.fui.builder.xml.creators.skins.AbstractSkinCreator;
   import net.bigpoint.darkorbit.fui.components.core.skins.ISkin;
   import net.bigpoint.darkorbit.fui.components.text.label.LabelSkin;
   
   public class LabelSkinCreator extends AbstractSkinCreator
   {
      
      public function LabelSkinCreator()
      {
         super();
      }
      
      override public function create(param1:XML) : ISkin
      {
         var _loc2_:ISkin = new LabelSkin();
         if(param1.attribute("truncateText") != undefined)
         {
            (_loc2_ as LabelSkin).truncateText = isBoolean(param1.attribute("truncateText"));
         }
         registerSkin(param1,_loc2_);
         return _loc2_;
      }
   }
}

