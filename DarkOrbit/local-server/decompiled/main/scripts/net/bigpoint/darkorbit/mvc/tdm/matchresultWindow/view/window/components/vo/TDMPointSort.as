package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.vo
{
   import spark.collections.SortField;
   
   public class TDMPointSort extends SortField
   {
      
      public function TDMPointSort(param1:String = null, param2:Boolean = false, param3:Object = null)
      {
         super(param1,param2,param3);
         compareFunction = this.compareMyPoints;
      }
      
      private function compareMyPoints(param1:Object, param2:Object) : int
      {
         var _loc3_:TDMResultWindowTabContentVo = param1 as TDMResultWindowTabContentVo;
         var _loc4_:TDMResultWindowTabContentVo = param2 as TDMResultWindowTabContentVo;
         if(Boolean(_loc3_) && Boolean(_loc4_))
         {
            return parseInt(_loc4_.palyerNameLable.right) - parseInt(_loc3_.palyerNameLable.right);
         }
         return 0;
      }
   }
}

