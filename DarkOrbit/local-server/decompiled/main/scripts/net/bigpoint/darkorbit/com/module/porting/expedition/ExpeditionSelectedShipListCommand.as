package net.bigpoint.darkorbit.com.module.porting.expedition
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class ExpeditionSelectedShipListCommand implements IModule
   {
      
      private static var _instance:ExpeditionSelectedShipListCommand;
      
      public var shipCommands:Vector.<ExpeditionShipCommand>;
      
      public var selectedHangarId:int = 0;
      
      public function ExpeditionSelectedShipListCommand(param1:int = 0, param2:Vector.<ExpeditionShipCommand> = null)
      {
         super();
         if(param2 == null)
         {
            this.shipCommands = new Vector.<ExpeditionShipCommand>();
         }
         else
         {
            this.shipCommands = param2;
         }
         this.selectedHangarId = param1;
      }
      
      public static function get instance() : ExpeditionSelectedShipListCommand
      {
         return _instance || (_instance = new ExpeditionSelectedShipListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -3201;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ExpeditionShipCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.shipCommands.length > 0)
         {
            this.shipCommands.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ExpeditionShipCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.shipCommands.push(_loc4_);
            _loc2_++;
         }
         this.selectedHangarId = param1.readInt();
         this.selectedHangarId = this.selectedHangarId << 1 % 32 | this.selectedHangarId >>> 32 - 1 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ExpeditionShipCommand = null;
         param1.writeShort(-3201);
         param1.writeByte(this.shipCommands.length);
         for each(_loc2_ in this.shipCommands)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.selectedHangarId >>> 1 % 32 | this.selectedHangarId << 32 - 1 % 32);
      }
   }
}

