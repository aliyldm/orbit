package net.bigpoint.darkorbit.mvc.crafting.assembly.model
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeBuildStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeReadyToCollectStatusModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.delete_in_eic.TraitTypes;
   
   public class AssemblyInventoryIndex
   {
      
      private var items:Dictionary = new Dictionary();
      
      private var amounts:Dictionary = new Dictionary();
      
      private var dependents:Dictionary = new Dictionary();
      
      private var blockedTargets:Dictionary = new Dictionary();
      
      private var queued:Dictionary = new Dictionary();
      
      private var dirty:Vector.<String> = new Vector.<String>(0);
      
      private var revision:uint;
      
      private var flushing:Boolean;
      
      public function AssemblyInventoryIndex()
      {
         super();
      }
      
      public function reset() : void
      {
         this.items = new Dictionary();
         this.amounts = new Dictionary();
         this.dependents = new Dictionary();
         this.blockedTargets = new Dictionary();
         this.queued = new Dictionary();
         this.dirty.length = 0;
         ++this.revision;
      }
      
      public function rebuildRecipes(param1:Vector.<AssemblyRecipeModel>) : void
      {
         var _loc2_:AssemblyRecipeModel = null;
         var _loc3_:AssemblyLootCount = null;
         var _loc4_:Vector.<AssemblyLootCount> = null;
         this.dependents = new Dictionary();
         for each(_loc2_ in param1)
         {
            for each(_loc3_ in _loc2_.ingredients)
            {
               _loc4_ = this.dependents[_loc3_.lootId];
               if(_loc4_ == null)
               {
                  _loc4_ = new Vector.<AssemblyLootCount>(0);
                  this.dependents[_loc3_.lootId] = _loc4_;
               }
               _loc4_.push(_loc3_);
               this.enqueue(_loc3_.lootId);
            }
         }
         ++this.revision;
      }
      
      public function updateRecipeStates(param1:Vector.<AssemblyRecipeModel>, param2:Dictionary) : void
      {
         var _loc5_:AssemblyRecipeModel = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc3_:Dictionary = new Dictionary();
         var _loc4_:Dictionary = new Dictionary();
         for each(_loc5_ in param1)
         {
            if(!_loc4_[_loc5_.targetId])
            {
               _loc4_[_loc5_.targetId] = true;
               _loc7_ = _loc5_.state.status.getLibcomModuleId();
               if(_loc7_ == AssemblyRecipeBuildStatusModule.instance.getLibcomModuleId() || _loc7_ == AssemblyRecipeReadyToCollectStatusModule.instance.getLibcomModuleId())
               {
                  _loc3_[_loc5_.targetId] = true;
               }
            }
         }
         for(_loc6_ in this.blockedTargets)
         {
            if(!_loc3_[_loc6_])
            {
               param2[_loc6_] = true;
            }
         }
         for(_loc6_ in _loc3_)
         {
            if(!this.blockedTargets[_loc6_])
            {
               param2[_loc6_] = true;
            }
         }
         this.blockedTargets = _loc3_;
      }
      
      public function updateItem(param1:Number, param2:ItemVO) : void
      {
         var _loc3_:String = param2 == null ? null : param2.lootID;
         var _loc4_:Number = param2 != null && !param2.isEquipped && (param2.id == 0 || param2.item.traits.getTraitByType(TraitTypes.UPGRADABLE) == null || !this.blockedTargets[param2.id]) ? param2.amount : 0;
         var _loc5_:Object = this.items[param1];
         if(_loc5_ != null)
         {
            if(param2 != null && _loc5_.lootId == _loc3_ && _loc5_.amount == _loc4_)
            {
               return;
            }
            this.addAmount(_loc5_.lootId,-_loc5_.amount);
         }
         if(param2 == null)
         {
            delete this.items[param1];
         }
         else
         {
            if(_loc5_ == null)
            {
               this.items[param1] = {
                  "lootId":_loc3_,
                  "amount":_loc4_
               };
            }
            else
            {
               _loc5_.lootId = _loc3_;
               _loc5_.amount = _loc4_;
            }
            this.addAmount(_loc3_,_loc4_);
         }
      }
      
      private function addAmount(param1:String, param2:Number) : void
      {
         if(param2 == 0)
         {
            return;
         }
         var _loc3_:Number = this.amounts[param1] === undefined ? 0 : Number(this.amounts[param1]);
         var _loc4_:Number = _loc3_ + param2;
         if(_loc4_ == 0)
         {
            delete this.amounts[param1];
         }
         else
         {
            this.amounts[param1] = _loc4_;
         }
         this.enqueue(param1);
         ++this.revision;
      }
      
      private function enqueue(param1:String) : void
      {
         if(!this.queued[param1])
         {
            this.queued[param1] = true;
            this.dirty.push(param1);
         }
      }
      
      public function flush() : Boolean
      {
         var changed:Boolean;
         var lootId:String = null;
         var targets:Vector.<AssemblyLootCount> = null;
         var version:uint = 0;
         var target:AssemblyLootCount = null;
         var value:Number = NaN;
         if(this.flushing)
         {
            return false;
         }
         this.flushing = true;
         changed = false;
         try
         {
            while(this.dirty.length != 0)
            {
               lootId = this.dirty.pop();
               delete this.queued[lootId];
               targets = this.dependents[lootId];
               if(targets != null)
               {
                  try
                  {
                     version = this.revision;
                     for each(target in targets)
                     {
                        value = this.amounts[lootId] === undefined ? 0 : Number(this.amounts[lootId]);
                        if(target.count.value != value)
                        {
                           target.setCount(value);
                           changed = true;
                           if(version != this.revision)
                           {
                              this.enqueue(lootId);
                              break;
                           }
                        }
                     }
                  }
                  catch(error:Error)
                  {
                     enqueue(lootId);
                     throw error;
                  }
               }
            }
         }
         finally
         {
            this.flushing = false;
         }
         return changed;
      }
   }
}

