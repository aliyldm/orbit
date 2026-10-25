package net.bigpoint.darkorbit.mvc.common.model.vo
{
   import com.bigpoint.utils.PointLite;
   
   public class ViewportResizeValuesVO
   {
      
      private var _beforResize:PointLite;
      
      private var _afterResize:PointLite;
      
      public function ViewportResizeValuesVO(param1:PointLite)
      {
         super();
         this._beforResize = this._afterResize = param1;
      }
      
      public function get beforeResize() : PointLite
      {
         return this._beforResize;
      }
      
      public function set beforeResize(param1:PointLite) : void
      {
         this._beforResize = param1;
      }
      
      public function get afterResize() : PointLite
      {
         return this._afterResize;
      }
      
      public function set afterResize(param1:PointLite) : void
      {
         this._afterResize = param1;
      }
   }
}

