# Створюємо маршрутну таблицю для публічних підмереж
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id # Прив'язуємо таблицю до нашої VPC

  tags = {
    Name = "${var.vpc_name}-public-rt" # Тег для таблиці маршрутів
  }
}

# Додаємо маршрут для виходу в інтернет через Internet Gateway
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id   # ID таблиці маршрутів
  destination_cidr_block = "0.0.0.0/0"                 # Всі IP-адреси
  gateway_id             = aws_internet_gateway.igw.id # Вказуємо Internet Gateway як вихід
}

# Прив'язуємо таблицю маршрутів до публічних підмереж
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets) # Прив'язуємо кожну підмережу
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Elastic IP для NAT Gateway — статична публічна адреса
resource "aws_eip" "nat" {
  domain = "vpc" # EIP у межах VPC

  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
}

# NAT Gateway — дозволяє приватним підмережам вихід в інтернет без вхідного доступу
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id          # Прив'язуємо EIP до NAT
  subnet_id     = aws_subnet.public[0].id # NAT живе в публічній підмережі

  tags = {
    Name = "${var.vpc_name}-nat"
  }

  depends_on = [aws_internet_gateway.igw] # NAT потребує IGW для виходу
}

# Маршрутна таблиця для приватних підмереж
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

# Маршрут для приватних підмереж в інтернет через NAT Gateway
resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"            # Весь вихідний трафік
  nat_gateway_id         = aws_nat_gateway.nat.id # Через NAT Gateway
}

# Прив'язуємо приватну таблицю маршрутів до приватних підмереж
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
