package net.bigpoint.darkorbit.mvc.traininggrounds.model
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.bindables.BindableObject;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class VictoryPointsMapAssetElement extends MapEntity
   {
      
      public const infoVO:BindableObject = new BindableObject();
      
      public function VictoryPointsMapAssetElement()
      {
         super(Map.NEXT_FREE_ID,new PointLite(4900,2700));
         UberAssetsLib.instance.fillTraits(this,"trainingArenaScore",UberAssetsLib.LIB_DEFAULT);
      }
      
      public function get data() : TraininggroundsFightInfoVO
      {
         return this.infoVO.value as TraininggroundsFightInfoVO;
      }
   }
}

