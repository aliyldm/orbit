package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UserKeyBindingsUpdate implements IModule
   {
      
      private static var _instance:UserKeyBindingsUpdate;
      
      public var changedKeyBindings:Vector.<UserKeyBindingsModule>;
      
      public var remove:Boolean = false;
      
      public function UserKeyBindingsUpdate(param1:Vector.<UserKeyBindingsModule> = null, param2:Boolean = false)
      {
         super();
         if(param1 == null)
         {
            this.changedKeyBindings = new Vector.<UserKeyBindingsModule>();
         }
         else
         {
            this.changedKeyBindings = param1;
         }
         this.remove = param2;
      }
      
      public static function get instance() : UserKeyBindingsUpdate
      {
         return _instance || (_instance = new UserKeyBindingsUpdate());
      }
      
      public function getLibcomModuleId() : int
      {
         return 801;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:UserKeyBindingsModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.changedKeyBindings.length > 0)
         {
            this.changedKeyBindings.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = UserKeyBindingsModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.changedKeyBindings.push(_loc4_);
            _loc2_++;
         }
         this.remove = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:UserKeyBindingsModule = null;
         param1.writeShort(801);
         param1.writeByte(this.changedKeyBindings.length);
         for each(_loc2_ in this.changedKeyBindings)
         {
            _loc2_.write(param1);
         }
         param1.writeBoolean(this.remove);
      }
   }
}

