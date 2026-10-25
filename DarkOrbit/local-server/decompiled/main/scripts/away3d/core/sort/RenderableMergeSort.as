package away3d.core.sort
{
   import away3d.core.data.RenderableListItem;
   import away3d.core.traverse.EntityCollector;
   
   public class RenderableMergeSort implements IEntitySorter
   {
      
      public function RenderableMergeSort()
      {
         super();
      }
      
      public function sort(param1:EntityCollector) : void
      {
         param1.opaqueRenderableHead = this.mergeSortByMaterial(param1.opaqueRenderableHead);
         param1.blendedRenderableHead = this.mergeSortByDepth(param1.blendedRenderableHead);
      }
      
      private function mergeSortByDepth(param1:RenderableListItem) : RenderableListItem
      {
         var _loc2_:RenderableListItem = null;
         var _loc3_:RenderableListItem = null;
         var _loc4_:RenderableListItem = null;
         var _loc5_:RenderableListItem = null;
         var _loc6_:RenderableListItem = null;
         var _loc7_:RenderableListItem = null;
         if(!param1 || !param1.next)
         {
            return param1;
         }
         _loc4_ = param1;
         _loc3_ = param1.next;
         while(_loc3_)
         {
            _loc3_ = _loc3_.next;
            if(_loc3_)
            {
               _loc4_ = _loc4_.next;
               _loc3_ = _loc3_.next;
            }
         }
         _loc2_ = _loc4_.next;
         _loc4_.next = null;
         param1 = this.mergeSortByDepth(param1);
         _loc2_ = this.mergeSortByDepth(_loc2_);
         if(!param1)
         {
            return _loc2_;
         }
         if(!_loc2_)
         {
            return param1;
         }
         while(Boolean(param1 && _loc2_) && Boolean(param1 != null) && _loc2_ != null)
         {
            if(param1.zIndex < _loc2_.zIndex)
            {
               _loc7_ = param1;
               param1 = param1.next;
            }
            else
            {
               _loc7_ = _loc2_;
               _loc2_ = _loc2_.next;
            }
            if(!_loc5_)
            {
               _loc5_ = _loc7_;
            }
            else
            {
               _loc6_.next = _loc7_;
            }
            _loc6_ = _loc7_;
         }
         if(param1)
         {
            _loc6_.next = param1;
         }
         else if(_loc2_)
         {
            _loc6_.next = _loc2_;
         }
         return _loc5_;
      }
      
      private function mergeSortByMaterial(param1:RenderableListItem) : RenderableListItem
      {
         var _loc2_:RenderableListItem = null;
         var _loc3_:RenderableListItem = null;
         var _loc4_:RenderableListItem = null;
         var _loc5_:RenderableListItem = null;
         var _loc6_:RenderableListItem = null;
         var _loc7_:RenderableListItem = null;
         var _loc8_:int = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         if(!param1 || !param1.next)
         {
            return param1;
         }
         _loc4_ = param1;
         _loc3_ = param1.next;
         while(_loc3_)
         {
            _loc3_ = _loc3_.next;
            if(_loc3_)
            {
               _loc4_ = _loc4_.next;
               _loc3_ = _loc3_.next;
            }
         }
         _loc2_ = _loc4_.next;
         _loc4_.next = null;
         param1 = this.mergeSortByMaterial(param1);
         _loc2_ = this.mergeSortByMaterial(_loc2_);
         if(!param1)
         {
            return _loc2_;
         }
         if(!_loc2_)
         {
            return param1;
         }
         while(Boolean(param1 && _loc2_) && Boolean(param1 != null) && _loc2_ != null)
         {
            _loc9_ = uint(param1.renderOrderId);
            _loc10_ = uint(_loc2_.renderOrderId);
            if(_loc9_ == _loc10_)
            {
               _loc11_ = uint(param1.materialId);
               _loc12_ = uint(_loc2_.materialId);
               if(_loc11_ == _loc12_)
               {
                  if(param1.zIndex < _loc2_.zIndex)
                  {
                     _loc8_ = 1;
                  }
                  else
                  {
                     _loc8_ = -1;
                  }
               }
               else if(_loc11_ > _loc12_)
               {
                  _loc8_ = 1;
               }
               else
               {
                  _loc8_ = -1;
               }
            }
            else if(_loc9_ > _loc10_)
            {
               _loc8_ = 1;
            }
            else
            {
               _loc8_ = -1;
            }
            if(_loc8_ < 0)
            {
               _loc7_ = param1;
               param1 = param1.next;
            }
            else
            {
               _loc7_ = _loc2_;
               _loc2_ = _loc2_.next;
            }
            if(!_loc5_)
            {
               _loc5_ = _loc7_;
               _loc6_ = _loc7_;
            }
            else
            {
               _loc6_.next = _loc7_;
               _loc6_ = _loc7_;
            }
         }
         if(param1)
         {
            _loc6_.next = param1;
         }
         else if(_loc2_)
         {
            _loc6_.next = _loc2_;
         }
         return _loc5_;
      }
   }
}

