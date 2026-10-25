package away3d.core.partition
{
   import away3d.core.base.IRenderable;
   import away3d.core.traverse.PartitionTraverser;
   import away3d.entities.Entity;
   
   public class RenderableNode extends EntityNode
   {
      
      private var _renderable:IRenderable;
      
      public function RenderableNode(param1:IRenderable)
      {
         super(Entity(param1));
         this._renderable = param1;
      }
      
      override public function acceptTraverser(param1:PartitionTraverser) : void
      {
         if(param1.enterNode(this))
         {
            super.acceptTraverser(param1);
            param1.applyRenderable(this._renderable);
         }
      }
   }
}

