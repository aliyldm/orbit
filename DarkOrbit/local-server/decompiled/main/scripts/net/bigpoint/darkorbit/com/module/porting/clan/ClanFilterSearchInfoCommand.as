package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class ClanFilterSearchInfoCommand implements IModule
   {
      
      private static var _instance:ClanFilterSearchInfoCommand;
      
      public var list:Vector.<ClanInfoCommand>;
      
      public var count:int = 0;
      
      public function ClanFilterSearchInfoCommand(param1:Vector.<ClanInfoCommand> = null, param2:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.list = new Vector.<ClanInfoCommand>();
         }
         else
         {
            this.list = param1;
         }
         this.count = param2;
      }
      
      public static function get instance() : ClanFilterSearchInfoCommand
      {
         return _instance || (_instance = new ClanFilterSearchInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1394;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ClanInfoCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.list.length > 0)
         {
            this.list.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ClanInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.list.push(_loc4_);
            _loc2_++;
         }
         this.count = param1.readInt();
         this.count = this.count >>> 8 % 32 | this.count << 32 - 8 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ClanInfoCommand = null;
         param1.writeShort(1394);
         param1.writeByte(this.list.length);
         for each(_loc2_ in this.list)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.count << 8 % 32 | this.count >>> 32 - 8 % 32);
      }
   }
}

