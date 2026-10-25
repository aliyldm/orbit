package net.bigpoint.darkorbit.map.model.env.mine
{
   import net.bigpoint.darkorbit.map.model.Map;
   
   public class MineCommon extends Mine
   {
      
      public function MineCommon(param1:int, param2:int, param3:int, param4:String, param5:int = 0, param6:int = 0)
      {
         super(param1,param2,param3,Map.getNextIdForHash(param4),param5,param6);
      }
   }
}

