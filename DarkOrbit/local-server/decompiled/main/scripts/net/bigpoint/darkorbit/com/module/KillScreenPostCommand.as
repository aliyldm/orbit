package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class KillScreenPostCommand implements IModule
   {
      
      private static var _instance:KillScreenPostCommand;
      
      public var killerName:String = "";
      
      public var killerEpppLink:String = "";
      
      public var playerShipAlias:String = "";
      
      public var cause:DestructionTypeModule;
      
      public var options:Vector.<KillScreenOptionModule>;
      
      public function KillScreenPostCommand(param1:String = "", param2:String = "", param3:String = "", param4:DestructionTypeModule = null, param5:Vector.<KillScreenOptionModule> = null)
      {
         super();
         this.killerName = param1;
         this.killerEpppLink = param2;
         this.playerShipAlias = param3;
         if(param4 == null)
         {
            this.cause = new DestructionTypeModule();
         }
         else
         {
            this.cause = param4;
         }
         if(param5 == null)
         {
            this.options = new Vector.<KillScreenOptionModule>();
         }
         else
         {
            this.options = param5;
         }
      }
      
      public static function get instance() : KillScreenPostCommand
      {
         return _instance || (_instance = new KillScreenPostCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 252;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:KillScreenOptionModule = null;
         this.killerName = param1.readUTF();
         this.killerEpppLink = param1.readUTF();
         this.playerShipAlias = param1.readUTF();
         this.cause = DestructionTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.cause)
         {
            this.cause.read(param1);
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.options.length > 0)
         {
            this.options.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = KillScreenOptionModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.options.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:KillScreenOptionModule = null;
         param1.writeShort(252);
         param1.writeUTF(this.killerName);
         param1.writeUTF(this.killerEpppLink);
         param1.writeUTF(this.playerShipAlias);
         if(null != this.cause)
         {
            this.cause.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.options.length);
         for each(_loc2_ in this.options)
         {
            _loc2_.write(param1);
         }
      }
   }
}

