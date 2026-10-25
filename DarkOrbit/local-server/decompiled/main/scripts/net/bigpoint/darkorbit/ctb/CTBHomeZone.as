package net.bigpoint.darkorbit.ctb
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class CTBHomeZone extends MapEntity
   {
      
      public function CTBHomeZone(param1:int, param2:int, param3:int, param4:int)
      {
         super(param1,new PointLite(param3,param4));
         UberAssetsLib.instance.fillTraits(this,"ctbHomeZone_" + param2,UberAssetsLib.LIB_DEFAULT);
      }
      
      override public function deactivateEntity() : void
      {
         super.deactivateEntity();
      }
   }
}

