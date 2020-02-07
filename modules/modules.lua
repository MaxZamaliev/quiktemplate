-------------------------------------------------------------------------------------------------------------------------------------------
--
-- modules.lua - компоновщик модулей
-- (с)2020 Max Zamaliev <zamal@inbox.ru>
--
-------------------------------------------------------------------------------------------------------------------------------------------
--

package.path = package.path..";"..getScriptPath().."\\modules\\moex\\?.lua"
package.path = package.path..";"..getScriptPath().."\\modules\\my\\?.lua"
package.path = package.path..";"..getScriptPath().."\\modules\\system\\?.lua"

log     = require "log"
mytable = require "mytable"
bond    = require "bond"
stock   = require "stock"
futures = require "futures"
