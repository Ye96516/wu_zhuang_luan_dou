extends Node

## 数学计算静态工具类
## 提供各种常用的数学计算函数，所有方法都是静态方法
class_name M

## 常量定义
const PI: float = 3.141592653589793
const TAU: float = 6.283185307179586
const E: float = 2.718281828459045
const DEG_TO_RAD: float = PI / 180.0
const RAD_TO_DEG: float = 180.0 / PI

## 向量计算相关
#-------------------------------------------------------------------------------

## 计算两个向量之间的角度（弧度）
## @param from: 起始向量
## @param to: 目标向量
## @return: 从from到to的角度（弧度），范围[-PI, PI]
static func angle_between(from: Vector2, to: Vector2) -> float:
	return from.angle_to(to)

## 计算两个向量之间的角度（角度）
## @param from: 起始向量
## @param to: 目标向量
## @return: 从from到to的角度（度），范围[-180, 180]
static func angle_between_degrees(from: Vector2, to: Vector2) -> float:
	return rad_to_deg(from.angle_to(to))

## 计算点到直线的距离
## @param point: 点坐标
## @param line_start: 直线起点
## @param line_end: 直线终点
## @return: 点到直线的距离
static func distance_to_line(point: Vector2, line_start: Vector2, line_end: Vector2) -> float:
	var line_vec: Vector2 = line_end - line_start
	var point_vec: Vector2 = point - line_start
	var line_length_squared: float = line_vec.length_squared()
	
	if line_length_squared == 0:
		return point_vec.length()
	
	var t: float = max(0, min(1, point_vec.dot(line_vec) / line_length_squared))
	var projection: Vector2 = line_start + t * line_vec
	return point.distance_to(projection)

## 数值计算相关
#-------------------------------------------------------------------------------

## 线性插值
## @param a: 起始值
## @param b: 结束值
## @param t: 插值系数 [0, 1]
## @return: 插值结果
static func lerp(a: float, b: float, t: float) -> float:
	return a + (b - a) * t

## 角度线性插值（处理角度环绕）
## @param a: 起始角度（弧度）
## @param b: 结束角度（弧度）
## @param t: 插值系数 [0, 1]
## @return: 插值后的角度（弧度）
static func lerp_angle(a: float, b: float, t: float) -> float:
	var diff: float = fmod(b - a, TAU)
	if diff > PI:
		diff -= TAU
	elif diff < -PI:
		diff += TAU
	return a + diff * t

## 角度线性插值（度）
## @param a: 起始角度（度）
## @param b: 结束角度（度）
## @param t: 插值系数 [0, 1]
## @return: 插值后的角度（度）
static func lerp_angle_degrees(a: float, b: float, t: float) -> float:
	var a_rad: float = deg_to_rad(a)
	var b_rad: float = deg_to_rad(b)
	var result_rad: float = lerp_angle(a_rad, b_rad, t)
	return rad_to_deg(result_rad)

## 平滑阻尼（类似Unity的Mathf.SmoothDamp）
## @param current: 当前值
## @param target: 目标值
## @param current_velocity: 当前速度（引用，会被修改）
## @param smooth_time: 平滑时间
## @param max_speed: 最大速度（可选）
## @param delta_time: 时间增量
## @return: 平滑后的值
static func smooth_damp(
	current: float, 
	target: float, 
	current_velocity: float, 
	smooth_time: float, 
	max_speed: float = INF, 
	delta_time: float = 1.0/60.0
) -> float:
	smooth_time = max(0.0001, smooth_time)
	var omega: float = 2.0 / smooth_time
	var x: float = omega * delta_time
	var exp: float = 1.0 / (1.0 + x + 0.48 * x * x + 0.235 * x * x * x)
	var change: float = current - target
	var original_to: float = target
	
	# 限制最大速度
	var max_change: float = max_speed * smooth_time
	change = clamp(change, -max_change, max_change)
	target = current - change
	
	var temp: float = (current_velocity + omega * change) * delta_time
	current_velocity = (current_velocity - omega * temp) * exp
	var output: float = target + (change + temp) * exp
	
	# 防止过冲
	if (original_to - current > 0.0) == (output > original_to):
		output = original_to
		current_velocity = (output - original_to) / delta_time
	
	return output

## 将值限制在指定范围内
## @param value: 输入值
## @param min_val: 最小值
## @param max_val: 最大值
## @return: 限制后的值
static func clamp(value: float, min_val: float, max_val: float) -> float:
	if value < min_val:
		return min_val
	elif value > max_val:
		return max_val
	return value

## 将值限制在0-1范围内
## @param value: 输入值
## @return: 限制后的值
static func clamp01(value: float) -> float:
	return clamp(value, 0.0, 1.0)

## 将值从一个范围映射到另一个范围
## @param value: 输入值
## @param from_min: 原范围最小值
## @param from_max: 原范围最大值
## @param to_min: 目标范围最小值
## @param to_max: 目标范围最大值
## @return: 映射后的值
static func map_range(
	value: float, 
	from_min: float, 
	from_max: float, 
	to_min: float, 
	to_max: float
) -> float:
	return (value - from_min) / (from_max - from_min) * (to_max - to_min) + to_min

## 将值从一个范围映射到0-1范围
## @param value: 输入值
## @param from_min: 原范围最小值
## @param from_max: 原范围最大值
## @return: 映射后的值 [0, 1]
static func map_range_01(value: float, from_min: float, from_max: float) -> float:
	return map_range(value, from_min, from_max, 0.0, 1.0)

## 将值从0-1范围映射到指定范围
## @param value: 输入值 [0, 1]
## @param to_min: 目标范围最小值
## @param to_max: 目标范围最大值
## @return: 映射后的值
static func map_01_to_range(value: float, to_min: float, to_max: float) -> float:
	return map_range(value, 0.0, 1.0, to_min, to_max)

## 几何计算相关
#-------------------------------------------------------------------------------

## 计算两点之间的距离
## @param a: 点A
## @param b: 点B
## @return: 两点之间的距离
static func distance(a: Vector2, b: Vector2) -> float:
	return a.distance_to(b)

## 计算两点之间距离的平方（性能更好）
## @param a: 点A
## @param b: 点B
## @return: 两点之间距离的平方
static func distance_squared(a: Vector2, b: Vector2) -> float:
	return (a - b).length_squared()

## 检查点是否在矩形内
## @param point: 点坐标
## @param rect_position: 矩形位置
## @param rect_size: 矩形大小
## @return: 如果点在矩形内返回true
static func point_in_rect(point: Vector2, rect_position: Vector2, rect_size: Vector2) -> bool:
	return (
		point.x >= rect_position.x and 
		point.x <= rect_position.x + rect_size.x and
		point.y >= rect_position.y and 
		point.y <= rect_position.y + rect_size.y
	)

## 检查点是否在圆形内
## @param point: 点坐标
## @param circle_center: 圆心坐标
## @param circle_radius: 圆半径
## @return: 如果点在圆形内返回true
static func point_in_circle(point: Vector2, circle_center: Vector2, circle_radius: float) -> bool:
	return distance_squared(point, circle_center) <= circle_radius * circle_radius

## 随机数相关
#-------------------------------------------------------------------------------

## 生成随机浮点数 [min_val, max_val]
## @param min_val: 最小值
## @param max_val: 最大值
## @return: 随机浮点数
static func random_range(min_val: float, max_val: float) -> float:
	return randf_range(min_val, max_val)

## 生成随机整数 [min_val, max_val]
## @param min_val: 最小值
## @param max_val: 最大值
## @return: 随机整数
static func random_range_int(min_val: int, max_val: int) -> int:
	return randi_range(min_val, max_val)

## 随机返回true或false
## @param probability: 返回true的概率 [0, 1]
## @return: 随机布尔值
static func random_bool(probability: float = 0.5) -> bool:
	return randf() < probability

## 从数组中随机选择一个元素
## @param array: 数组
## @return: 随机选择的元素，如果数组为空返回null
static func random_choice(array: Array) -> Variant:
	if array.is_empty():
		return null
	return array[randi() % array.size()]

## 从权重数组中随机选择一个索引
## @param weights: 权重数组
## @return: 根据权重随机选择的索引
static func random_weighted_choice(weights: Array) -> int:
	if weights.is_empty():
		return -1
	
	var total_weight: float = 0.0
	for weight in weights:
		total_weight += weight
	
	if total_weight <= 0:
		return randi() % weights.size()
	
	var random_value: float = randf() * total_weight
	var cumulative_weight: float = 0.0
	
	for i in range(weights.size()):
		cumulative_weight += weights[i]
		if random_value <= cumulative_weight:
			return i
	
	return weights.size() - 1

## 单位转换相关
#-------------------------------------------------------------------------------

## 角度转弧度
## @param degrees: 角度值
## @return: 弧度值
static func deg_to_rad(degrees: float) -> float:
	return degrees * DEG_TO_RAD

## 弧度转角度
## @param radians: 弧度值
## @return: 角度值
static func rad_to_deg(radians: float) -> float:
	return radians * RAD_TO_DEG

## 其他实用函数
#-------------------------------------------------------------------------------

## 判断两个浮点数是否近似相等
## @param a: 值A
## @param b: 值B
## @param epsilon: 允许的误差范围
## @return: 如果近似相等返回true
static func approximately(a: float, b: float, epsilon: float = 0.00001) -> bool:
	return abs(a - b) < epsilon

## 计算百分比
## @param value: 当前值
## @param total: 总值
## @return: 百分比值 [0, 100]
static func percentage(value: float, total: float) -> float:
	if total == 0:
		return 0.0
	return (value / total) * 100.0

## 计算百分比（0-1范围）
## @param value: 当前值
## @param total: 总值
## @return: 百分比值 [0, 1]
static func percentage_01(value: float, total: float) -> float:
	if total == 0:
		return 0.0
	return value / total

## 计算平均值
## @param values: 数值数组
## @return: 平均值
static func average(values: Array) -> float:
	if values.is_empty():
		return 0.0
	
	var sum: float = 0.0
	for value in values:
		sum += value
	
	return sum / values.size()

## 计算标准差
## @param values: 数值数组
## @return: 标准差
static func standard_deviation(values: Array) -> float:
	if values.is_empty():
		return 0.0
	
	var avg: float = average(values)
	var sum_squared_diff: float = 0.0
	
	for value in values:
		var diff: float = value - avg
		sum_squared_diff += diff * diff
	
	return sqrt(sum_squared_diff / values.size())

## 贝塞尔曲线计算
#-------------------------------------------------------------------------------

## 二次贝塞尔曲线
## @param p0: 起点
## @param p1: 控制点
## @param p2: 终点
## @param t: 参数 [0, 1]
## @return: 曲线上的点
static func bezier_quadratic(p0: Vector2, p1: Vector2, p2: Vector2, t: float) -> Vector2:
	var u: float = 1.0 - t
	var tt: float = t * t
	var uu: float = u * u
	
	return uu * p0 + 2.0 * u * t * p1 + tt * p2

## 三次贝塞尔曲线
## @param p0: 起点
## @param p1: 控制点1
## @param p2: 控制点2
## @param p3: 终点
## @param t: 参数 [0, 1]
## @return: 曲线上的点
static func bezier_cubic(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float) -> Vector2:
	var u: float = 1.0 - t
	var tt: float = t * t
	var uu: float = u * u
	var uuu: float = uu * u
	var ttt: float = tt * t
	
	return uuu * p0 + 3.0 * uu * t * p1 + 3.0 * u * tt * p2 + ttt * p3
