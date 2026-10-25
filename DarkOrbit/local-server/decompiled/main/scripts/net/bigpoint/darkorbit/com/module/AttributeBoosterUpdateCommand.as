package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AttributeBoosterUpdateCommand implements IModule
   {
      
      private static var _instance:AttributeBoosterUpdateCommand;
      
      public var boostedAttributes:Vector.<BoosterUpdateModule>;
      
      public var boostedDetailsUpdate:Vector.<BoosterDetailModule>;
      
      public var boostedDetailsRemove:Vector.<BoosterDetailModule>;
      
      public function AttributeBoosterUpdateCommand(param1:Vector.<BoosterUpdateModule> = null, param2:Vector.<BoosterDetailModule> = null, param3:Vector.<BoosterDetailModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.boostedAttributes = new Vector.<BoosterUpdateModule>();
         }
         else
         {
            this.boostedAttributes = param1;
         }
         if(param2 == null)
         {
            this.boostedDetailsUpdate = new Vector.<BoosterDetailModule>();
         }
         else
         {
            this.boostedDetailsUpdate = param2;
         }
         if(param3 == null)
         {
            this.boostedDetailsRemove = new Vector.<BoosterDetailModule>();
         }
         else
         {
            this.boostedDetailsRemove = param3;
         }
      }
      
      public static function get instance() : AttributeBoosterUpdateCommand
      {
         return _instance || (_instance = new AttributeBoosterUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 101;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:BoosterUpdateModule = null;
         var _loc5_:BoosterDetailModule = null;
         var _loc6_:BoosterDetailModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.boostedAttributes.length > 0)
         {
            this.boostedAttributes.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = BoosterUpdateModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.boostedAttributes.push(_loc4_);
            _loc2_++;
         }
         while(this.boostedDetailsUpdate.length > 0)
         {
            this.boostedDetailsUpdate.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = BoosterDetailModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.boostedDetailsUpdate.push(_loc5_);
            _loc2_++;
         }
         while(this.boostedDetailsRemove.length > 0)
         {
            this.boostedDetailsRemove.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc6_ = BoosterDetailModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc6_.read(param1);
            this.boostedDetailsRemove.push(_loc6_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:BoosterUpdateModule = null;
         var _loc3_:BoosterDetailModule = null;
         var _loc4_:BoosterDetailModule = null;
         param1.writeShort(101);
         param1.writeByte(this.boostedAttributes.length);
         for each(_loc2_ in this.boostedAttributes)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.boostedDetailsUpdate.length);
         for each(_loc3_ in this.boostedDetailsUpdate)
         {
            _loc3_.write(param1);
         }
         param1.writeByte(this.boostedDetailsRemove.length);
         for each(_loc4_ in this.boostedDetailsRemove)
         {
            _loc4_.write(param1);
         }
      }
   }
}

